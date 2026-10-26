package ru.foodshopmeal.infrastructure.health

import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.actuate.health.Health
import org.springframework.boot.actuate.health.HealthIndicator
import org.springframework.stereotype.Component
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.HeadBucketRequest
import java.net.URI

@Component("s3Storage")
class S3StorageHealthIndicator(
    @Value("\${fsm.s3.endpoint}") private val endpoint: String,
    @Value("\${fsm.s3.region}") private val region: String,
    @Value("\${fsm.s3.access-key}") private val accessKey: String,
    @Value("\${fsm.s3.secret-key}") private val secretKey: String,
    @Value("\${fsm.s3.bucket-feeds}") private val feedsBucket: String,
) : HealthIndicator, AutoCloseable {
    private val s3Client: S3Client =
        S3Client.builder()
            .endpointOverride(URI.create(endpoint))
            .region(Region.of(region))
            .forcePathStyle(true)
            .credentialsProvider(
                StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey)),
            )
            .build()

    override fun health(): Health =
        try {
            s3Client.headBucket(HeadBucketRequest.builder().bucket(feedsBucket).build())
            Health.up()
                .withDetail("endpoint", endpoint)
                .withDetail("feedsBucket", feedsBucket)
                .build()
        } catch (ex: Exception) {
            Health.down(ex)
                .withDetail("endpoint", endpoint)
                .withDetail("feedsBucket", feedsBucket)
                .build()
        }

    override fun close() {
        s3Client.close()
    }
}
