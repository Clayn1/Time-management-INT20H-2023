package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.InvitedUserDto;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import com.pivo.timemanagementbackend.rest.service.InvitationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/invitation")
public class InvitationController {
    @Autowired
    private InvitationService invitationService;

    @PostMapping("/event/{eventId}")
    public ResponseEntity<?> inviteUsers(@PathVariable("eventId") Integer eventId, @RequestBody List<String> emails) {
        invitationService.inviteUsers(eventId, emails);
        return new ResponseEntity<>(HttpStatus.ACCEPTED);
    }
    @PostMapping("/{invitationId}/accept")
    public ResponseEntity<Boolean> acceptInvite(@PathVariable("invitationId") Integer invitationId) {
        return ResponseEntity.ok(invitationService.resolveInvite(invitationId, InvitationStatus.ACCEPTED));
    }
    @PostMapping("/{invitationId}/decline")
    public ResponseEntity<Boolean> declineInvite(@PathVariable("invitationId") Integer invitationId) {
        return ResponseEntity.ok(invitationService.resolveInvite(invitationId, InvitationStatus.DECLINED));
    }
    @GetMapping
    public ResponseEntity<List<InvitedUserDto>> findInvitesByUserEmail(@RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return ResponseEntity.ok(invitationService.findAllPendingByToken(token));
    }
}
