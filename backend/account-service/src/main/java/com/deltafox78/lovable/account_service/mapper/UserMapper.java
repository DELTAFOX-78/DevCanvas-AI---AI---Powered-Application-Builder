package com.deltafox78.lovable.account_service.mapper;

import com.deltafox78.lovable.account_service.dto.auth.SignupRequest;
import com.deltafox78.lovable.account_service.dto.auth.UserProfileResponse;
import com.deltafox78.lovable.account_service.entity.User;
import com.deltafox78.lovable.common_lib.dto.UserDto;
import com.deltafox78.lovable.common_lib.security.JwtUserPrincipal;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {

    User toEntity(SignupRequest signupRequest);

    @Mapping(source = "userId", target = "id")
    UserProfileResponse toUserProfileResponse(JwtUserPrincipal user);

    UserDto toUserDto(User user);

}
