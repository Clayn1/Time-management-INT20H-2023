package com.pivo.timemanagementbackend.rest.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.pivo.timemanagementbackend.model.dto.Note;
import com.pivo.timemanagementbackend.model.entity.FirebaseToken;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.rest.repository.FirebaseTokenRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service
public class FirebaseMessagingService {
    private final Logger logger = LoggerFactory.getLogger(FirebaseMessagingService.class);

    @Autowired
    private FirebaseMessaging firebaseMessaging;
    @Autowired
    private FirebaseTokenRepository firebaseTokenRepository;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    public String sendNotification(Note note, String token) throws FirebaseMessagingException {

        Notification notification = Notification
                .builder()
                .setTitle(note.getSubject())
                .setBody(note.getContent())
                .build();

        Message message = Message
                .builder()
                .setToken(token)
                .setNotification(notification)
                .putAllData(note.getData() != null ? note.getData() : new HashMap<>())
                .build();

        return firebaseMessaging.send(message);
    }

    public void addToken(String firebaseToken, String authToken) {
        FirebaseToken firebaseTokenEntity = new FirebaseToken();
        firebaseTokenEntity.setToken(firebaseToken);
        User user = new User();
        user.setId(jwtTokenUtil.getIdFromToken(authToken));
        firebaseTokenEntity.setUser(user);
        try {
            firebaseTokenRepository.save(firebaseTokenEntity);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

    }
    public void removeToken(String firebaseToken) {
        firebaseTokenRepository.deleteFirebaseTokenByToken(firebaseToken);
    }

    public List<String> getFirebaseTokenByUserEmail(String email) {
        return firebaseTokenRepository.getFirebaseTokenByUserEmail(email);
    }
}
