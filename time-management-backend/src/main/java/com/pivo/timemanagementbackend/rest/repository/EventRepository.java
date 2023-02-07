package com.pivo.timemanagementbackend.rest.repository;

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
    @Query("select e " +
            "from event e " +
            "where e.user.email = :email " +
            "and (e.category in :category) " +
            "and (:name is null or lower(e.name) like lower(concat('%', :name, '%'))) " +
            "and (date(:date) is null or date(:date) >= date(e.dateStart) and date(:date) <= date(e.dateEnd))")
    List<Event> findEventsWithFilter(
            @Param("email") String email,
            @Param("category") List<Category> category,
            @Param("name") String name,
            @Param("date") Date date);

    @Query("select i.event " +
            "from invitation i " +
            "where i.user.email = :email " +
            "and i.status = 1 " +
            "and (i.event.category in :category) " +
            "and (:name is null or lower(i.event.name) like lower(concat('%', :name, '%'))) " +
            "and (date(:date) is null or date(:date) >= date(i.event.dateStart) and date(:date) <= date(i.event.dateEnd))")
    List<Event> findAcceptedEventsWithFilter(
            @Param("email") String email,
            @Param("category") List<Category> category,
            @Param("name") String name,
            @Param("date") Date date);
}
