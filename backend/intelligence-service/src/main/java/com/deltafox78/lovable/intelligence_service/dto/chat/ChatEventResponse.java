package com.deltafox78.lovable.intelligence_service.dto.chat;


import com.deltafox78.lovable.common_lib.enums.ChatEventType;

public record ChatEventResponse(
        Long id,
        ChatEventType type,
        Integer sequenceOrder,
        String content,
        String filePath,
        String metadata
) {
}
