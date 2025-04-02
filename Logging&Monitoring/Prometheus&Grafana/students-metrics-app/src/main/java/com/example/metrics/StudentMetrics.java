package com.example.metrics;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class StudentMetrics {

    private final MeterRegistry meterRegistry;

    @Value("${students.count}")
    private int studentCount;

    @Value("${pod.name:unknown}")
    private String podName;

    public StudentMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    @PostConstruct
    public void init() {
        Gauge.builder("number_of_students", () -> studentCount)
             .description("Number of students")
             .tag("pod", podName)
             .register(meterRegistry);
    }
}
