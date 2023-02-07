package com.pivo.timemanagementbackend.converter;

import jakarta.persistence.AttributeConverter;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class StringToListConverter implements AttributeConverter<List<String>, String> {
    @Override
    public String convertToDatabaseColumn(List<String> list) {
        if(list == null || list.isEmpty()) return null;
        return String.join(",", list);
    }

    @Override
    public List<String> convertToEntityAttribute(String joined) {
        if(StringUtils.isEmpty(joined)) return new ArrayList<>();
        return new ArrayList<>(Arrays.asList(joined.split(",")));
    }
}
