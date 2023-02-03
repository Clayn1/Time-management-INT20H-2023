package com.pivo.timemanagementbackend.rest.repository;

import com.pivo.timemanagementbackend.model.dto.InvitedUserDto;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InvitationRepository extends JpaRepository<InvitedUser, Integer> {
    @Query("select new com.pivo.timemanagementbackend.model.dto.InvitedUserDto(i.id, i.status, e.user.email, e.id, e.name, e.category, e.dateStart, e.dateEnd, i.issuedWhen) " +
            "from invitation i left join event e on i.event.id = e.id " +
            "where i.user.email = :email " +
            "and i.status = :status")
    List<InvitedUserDto> findAllByUser_EmailAndStatus(String email, InvitationStatus status);
    @Transactional
    @Modifying
    @Query("update invitation i set i.status = :status where i.id = :invitationId")
    Integer changeStatus(@Param("invitationId") Integer invitationId, @Param("status") InvitationStatus status);
}
