package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.InvitedUserDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import com.pivo.timemanagementbackend.rest.repository.InvitationRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class InvitationService {
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private InvitationRepository invitationRepository;

    public List<InvitedUser> inviteUsers(Integer eventId, List<String> emails) {
        List<InvitedUser> invites = emails.stream().map(email -> {
            InvitedUser invitedUser = new InvitedUser();
            User user = new User();
            user.setEmail(email);
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
