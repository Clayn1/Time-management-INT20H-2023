package com.pivo.timemanagementbackend.rest.service;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
public class S3BucketStorageService {
    private final Logger logger = LoggerFactory.getLogger(S3BucketStorageService.class);
    @Autowired
    private AmazonS3 amazonS3;
    @Value("${application.bucket.name}")
    private String bucketName;

    @Value("${application.bucket.url}")
    private String url;

    public String uploadFile(MultipartFile file) {
        String id = String.valueOf(file.hashCode());
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            amazonS3.putObject(bucketName, id, file.getInputStream(), metadata);
            return url + "/" + id + "." + FilenameUtils.getExtension(file.getOriginalFilename());
        } catch (IOException ioe) {
            logger.error("IOException: " + ioe.getMessage());
        } catch (AmazonServiceException serviceException) {
            logger.error("AmazonServiceException: "+ serviceException.getMessage());
            throw serviceException;
        } catch (AmazonClientException clientException) {
            logger.error("AmazonClientException Message: " + clientException.getMessage());
            throw clientException;
        }
        return null;
    }
}
