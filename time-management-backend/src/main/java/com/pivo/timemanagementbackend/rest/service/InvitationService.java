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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

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

    public List<InvitedUser> inviteUsers(Integer eventId, List<String> emails) {
        EventWithEmailDto existingEvent = eventService.findEventById(eventId);
        List<InvitedUser> invites = emails.stream().map(email -> {
            InvitedUser invitedUser = new InvitedUser();
            User user = new User();
            UserData userByEmail = userService.getUserByEmail(email);
            if (userByEmail == null) {
                Integer emptyUserId = userService.createEmptyUser(email);
                user.setEmail(email);
                user.setId(emptyUserId);
            } else {
                user.setEmail(userByEmail.getEmail());
                user.setId(userByEmail.getId());
                String firebaseTokenByUserEmail = fmService.getFirebaseTokenByUserEmail(userByEmail.getEmail());
                Note note = new Note();
                note.setSubject("You have been invited to \"" + existingEvent.getName() + "\"");
                note.setContent(userByEmail.getEmail() + " has invited you to " + existingEvent.getName() +
                        "\nDate: " + LocalDateTime.parse(
                        existingEvent.getDateStart().toString(), DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm")
                ));
                try {
                    fmService.sendNotification(note, firebaseTokenByUserEmail);
                } catch (FirebaseMessagingException e) {
                    logger.error(e.getMessage());
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
}
