package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.response.UploadVO;
import com.shizhuang.productreview.service.FileStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/merchant")
@RequiredArgsConstructor
public class FileUploadController {

    private final FileStorageService fileStorageService;

    @PostMapping("/images/upload")
    public ApiResult<UploadVO> uploadImage(@RequestParam("file") MultipartFile file) {
        String url = fileStorageService.upload(file);
        UploadVO vo = new UploadVO();
        vo.setUrl(url);
        vo.setOriginalName(file.getOriginalFilename());
        vo.setSize(file.getSize());
        return ApiResult.success(vo);
    }
}