package com.pivo.timemanagementbackend.rest.repository;

import com.pivo.timemanagementbackend.model.entity.FirebaseToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FirebaseTokenRepository extends JpaRepository<FirebaseToken, Integer> {
    void deleteFirebaseTokenByToken(String token);

    @Query("select token from token where user.email = :email")
    List<String> getFirebaseTokenByUserEmail(@Param("email") String email);
}
