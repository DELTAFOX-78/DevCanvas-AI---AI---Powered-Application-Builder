package com.deltafox78.lovable.account_service.dto.auth;

public record AuthResponse(
        String token,
        UserProfileResponse user
) {

}
