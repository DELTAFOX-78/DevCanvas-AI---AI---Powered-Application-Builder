package com.deltafox78.lovable.account_service.service;


import com.deltafox78.lovable.account_service.dto.auth.AuthResponse;
import com.deltafox78.lovable.account_service.dto.auth.LoginRequest;
import com.deltafox78.lovable.account_service.dto.auth.SignupRequest;

public interface AuthService {
    AuthResponse signup(SignupRequest request);

    AuthResponse login(LoginRequest request);
}
