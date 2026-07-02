package com.guzi.productreview.service;

import com.guzi.productreview.common.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.UUID;

@Slf4j
@Service
public class FileStorageService {

    @Value("${app.upload.base-path}")
    private String uploadBasePath;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_TYPES = {"image/png", "image/jpeg"};

    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(uploadBasePath));
        } catch (IOException e) {
            log.error("Could not create upload directory", e);
        }
    }

    public String upload(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BusinessException("文件不能为空");
        }

        String contentType = file.getContentType();
        boolean allowed = false;
        for (String type : ALLOWED_TYPES) {
            if (type.equals(contentType)) {
                allowed = true;
                break;
            }
        }
        if (!allowed) {
            throw new BusinessException("仅支持 PNG 和 JPEG 格式图片");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new BusinessException("文件大小不能超过 5MB");
        }

        String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        String ext = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
        String filename = UUID.randomUUID().toString() + ext;

        try {
            Path targetDir = Paths.get(uploadBasePath, dateDir);
            Files.createDirectories(targetDir);
            Path targetPath = targetDir.resolve(filename);
            file.transferTo(targetPath.toFile());

            return "/uploads/" + dateDir + "/" + filename;
        } catch (IOException e) {
            log.error("File upload failed", e);
            throw new BusinessException("文件上传失败");
        }
    }

    private String getExtension(String filename) {
        int dot = filename.lastIndexOf('.');
        return dot > 0 ? filename.substring(dot) : "";
    }
}