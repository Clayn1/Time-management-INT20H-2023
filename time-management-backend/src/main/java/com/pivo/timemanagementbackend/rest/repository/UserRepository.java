package com.pivo.timemanagementbackend.rest.repository;

import com.pivo.timemanagementbackend.model.dto.UserCredentials;
import com.pivo.timemanagementbackend.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    @Query("select new com.pivo.timemanagementbackend.model.dto.UserCredentials(u.email, u.password) from user as u where u.email = :email")
    UserCredentials findUserCredentialsByEmail(@Param("email") String email);
    User findUserByEmail(@Param("email") String email);
}
