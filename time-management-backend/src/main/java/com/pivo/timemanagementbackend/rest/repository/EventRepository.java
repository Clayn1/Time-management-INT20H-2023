package com.pivo.timemanagementbackend.rest.repository;

import com.pivo.timemanagementbackend.model.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Integer> {
    Event findEventById(Integer id);
    List<Event> findEventsByUser_Email(String email);
    List<Event> findEventsByUser_EmailAndCategory(String email, String category);

}
