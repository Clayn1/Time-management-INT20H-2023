package com.pivo.timemanagementbackend.rest.repository;

import com.pivo.timemanagementbackend.model.dto.EventPreview;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.enums.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Integer> {
    @Query("select new com.pivo.timemanagementbackend.model.dto.EventPreview(e.id, e.name, e.dateStart, e.dateEnd, e.category, e.user.email) " +
            "from event e " +
            "where e.user.email = :email " +
            "and (:category is null or e.category = :category) " +
            "and (:name is null or lower(e.name) like lower(concat('%', :name, '%')) ) " +
            "and (date(:date) is null or date(:date) >= date(e.dateStart) and date(:date) <= date(e.dateEnd))")
    List<EventPreview> findEventPreviewsWithFilter(
            @Param("email") String email,
            @Param("category") Category category,
            @Param("name") String name,
            @Param("date") Date date);

    @Query("select new com.pivo.timemanagementbackend.model.dto.EventPreview(i.event.id, i.event.name, i.event.dateStart, i.event.dateEnd, i.event.category, i.event.user.email) " +
            "from invitation i " +
            "where i.user.email = :email " +
            "and i.status = 1 " +
            "and (:category is null or i.event.category = :category) " +
            "and (:name is null or lower(i.event.name) like lower(concat('%', :name, '%'))) " +
            "and (date(:date) is null or date(:date) >= date(i.event.dateStart) and date(:date) <= date(i.event.dateEnd))")
    List<EventPreview> findAcceptedEventPreviewsWithFilter(
            @Param("email") String email,
            @Param("category") Category category,
            @Param("name") String name,
            @Param("date") Date date);
}
