package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.model.enums.Category;
import com.pivo.timemanagementbackend.rest.repository.EventRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.apache.commons.lang3.EnumUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class EventService {
    private final Logger logger = LoggerFactory.getLogger(EventService.class);
    @Autowired
    private S3BucketStorageService s3;
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private InvitationService invitationService;

    public EventWithEmailDto findEventById(Integer id) {
        Event event = eventRepository.findById(id).orElse(null);
        if (event != null) {
            return mapEntityToDto(event);
        } else {
            return null;
        }
    }

    public List<EventWithEmailDto> findEventPreviewsWithFilter(String token, String name, String category, Date date) {
        logger.info("findEventPreviewsWithFilter: token:{}, name:{}, category:{}, date:{}", token, name, category, date);
        String email = jwtTokenUtil.getUsernameFromToken(token);
        List<Category> categoryMapped = new ArrayList<>();
        if (category != null) {
            String[] split = category.split(",");
            for (String s : split) {
                if (EnumUtils.isValidEnum(Category.class, StringUtils.toRootUpperCase(s))) {
                    categoryMapped.add(Category.valueOf(StringUtils.toRootUpperCase(s)));
                }
            }
        }
        categoryMapped = categoryMapped.size() == 0 ? Arrays.stream(Category.values()).toList() : categoryMapped;
        logger.info(String.valueOf(categoryMapped));
        List<Event> eventPreviewsWithFilter = eventRepository
                .findEventPreviewsWithFilter(email, categoryMapped, name, date);
        List<Event> acceptedEventPreviewsWithFilter = eventRepository
                .findAcceptedEventPreviewsWithFilter(email, categoryMapped, name, date);
        if (acceptedEventPreviewsWithFilter.size() > 0) {
            eventPreviewsWithFilter.addAll(acceptedEventPreviewsWithFilter);
        }
        return eventPreviewsWithFilter
                .stream()
                .map(this::mapEntityToDto)
                .sorted(
                        Comparator.comparing(EventWithEmailDto::getDateStart)
                )
                .collect(Collectors.toList());
    }

    public Event createUpdateEvent(String token, EventDto event) {
        logger.info("Multiparts: {}", event.getDocuments());
        User user = new User();
        user.setEmail(jwtTokenUtil.getUsernameFromToken(token));
        user.setId(jwtTokenUtil.getIdFromToken(token));
        Event mappedEvent = mapDtoToEvent(event, user);
        if (event.getDocuments() != null) {
            ArrayList<String> docs = new ArrayList<>();
            for (MultipartFile document : event.getDocuments()) {
                docs.add(s3.uploadFile(document));
            }
            mappedEvent.setDocuments(docs);
        }
        logger.info("createUpdateEvent: {}", mappedEvent.getDocuments());
        Event savedEvent = eventRepository.save(mappedEvent);
        if (event.getParticipants() != null) {
            List<InvitedUser> invitedUsers = invitationService.inviteUsers(savedEvent.getId(), event.getParticipants());
            savedEvent.setParticipants(invitedUsers);
        }

        return savedEvent;
    }
    public void removeEvent(Integer eventId) {
        eventRepository.deleteById(eventId);
    }
    private Event mapDtoToEvent(EventDto eventDto, User user) {
        Event event = new Event();
        event.setId(eventDto.getId());
        event.setName(eventDto.getName());
        event.setUser(user);
        event.setDateStart(eventDto.getDateStart());
        event.setDateEnd(eventDto.getDateEnd());
        event.setDescription(eventDto.getDescription());
        event.setCategory(Category.valueOf(eventDto.getCategory()));
        event.setReminder(eventDto.getReminder());
        return event;
    }

    private EventWithEmailDto mapEntityToDto(Event event) {
        return new EventWithEmailDto(
                event.getId(),
                event.getName(),
                event.getDescription(),
                event.getDateStart(),
                event.getDateEnd(),
                event.getCategory(),
                event.getReminder(),
                event.getUser().getEmail(),
                event.getParticipants(),
                event.getDocuments()
        );
    }
}
