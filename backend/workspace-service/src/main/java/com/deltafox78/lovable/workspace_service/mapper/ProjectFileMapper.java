package com.deltafox78.lovable.workspace_service.mapper;

import com.deltafox78.lovable.common_lib.dto.FileNode;
import com.deltafox78.lovable.workspace_service.entity.ProjectFile;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProjectFileMapper {

    List<FileNode> toListOfFileNode(List<ProjectFile> projectFileList);
}
