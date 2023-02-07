package com.pivo.timemanagementbackend.rest.service;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.dto.InvitedUserDto;
import com.pivo.timemanagementbackend.model.dto.Note;
import com.pivo.timemanagementbackend.model.dto.UserData;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import com.pivo.timemanagementbackend.rest.repository.InvitationRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.aws.mail.simplemail.SimpleEmailServiceJavaMailSender;
import org.springframework.cloud.aws.mail.simplemail.SimpleEmailServiceMailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@Service
public class InvitationService {
    private final Logger logger = LoggerFactory.getLogger(InvitationService.class);
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private InvitationRepository invitationRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private FirebaseMessagingService fmService;
    @Autowired
    private EventService eventService;
    @Autowired
    private JavaMailSender mailSender;

    public List<InvitedUser> inviteUsers(Integer eventId, List<String> emails) {
        EventWithEmailDto existingEvent = eventService.findEventById(eventId);

        String subject = "You have been invited to \"" + existingEvent.getName() + "\"";
        String date = dateMap(existingEvent.getDateStart());
        String body = existingEvent.getEmail() + " has invited you to " + existingEvent.getName() + "\nDate: " + date;

        List<InvitedUser> invites = emails.stream().map(email -> {
            InvitedUser invitedUser = new InvitedUser();
            User user = new User();
            UserData userByEmail = userService.getUserByEmail(email);
            if (userByEmail == null) {
                sendEmail(email, subject, body);
                Integer emptyUserId = userService.createEmptyUser(email);
                user.setEmail(email);
                user.setId(emptyUserId);
            } else {
                user.setEmail(userByEmail.getEmail());
                user.setId(userByEmail.getId());
                List<String> firebaseTokensByUserEmail = fmService.getFirebaseTokenByUserEmail(userByEmail.getEmail());
                Note note = new Note();
                note.setSubject(subject);
                note.setContent(body);
                logger.info("Firebase Token: {}", firebaseTokensByUserEmail);
                for (String token : firebaseTokensByUserEmail) {
                    try {
                        fmService.sendNotification(note, token);
                    } catch (FirebaseMessagingException e) {
                        logger.error(e.getMessage());
                    }
                }

            }
            Event event = new Event();
            event.setId(eventId);
            invitedUser.setUser(user);
            invitedUser.setEvent(event);
            invitedUser.setIssuedWhen(new Date());
            return invitedUser;
        }).toList();
        return invitationRepository.saveAll(invites);
    }

    public Boolean resolveInvite(Integer invitationId, InvitationStatus status) {
        return invitationRepository.changeStatus(invitationId, status) > 0;
    }

    public List<InvitedUserDto> findAllPendingByToken(String token) {
        String email = jwtTokenUtil.getUsernameFromToken(token);
        return invitationRepository.findAllByUser_EmailAndStatus(email, InvitationStatus.PENDING);
    }

    public void sendEmail(String to, String subject, String body) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);

        mailSender.send(message);
    }

    private String dateMap(Date date) {
        try {
            SimpleDateFormat format = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy", Locale.ENGLISH);
            Date javaDate = format.parse(date.toString());
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM hh:mm");
            return dateFormat.format(javaDate);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}
