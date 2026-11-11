package com.deltafox78.lovable.workspace_service.dto.member;

import com.deltafox78.lovable.common_lib.enums.ProjectRole;
import jakarta.validation.constraints.NotNull;

public record UpdateMemberRoleRequest(
        @NotNull ProjectRole role) {
}
