# JaCoCo Code Coverage Integration for Java + Spring Boot (Maven)

This guide outlines the necessary steps and configuration to enable code coverage in a Java + Spring Boot application using **JaCoCo** with **Maven**.

---
## 1. Dependencies

No separate dependencies are required in the `<dependencies>` section for JaCoCo.

However, make sure the following test dependencies are present:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
</dependency>
```

---

## 2. Add JaCoCo Plugin

Insert the following plugin configuration into the `<build><plugins>` section of your `pom.xml`:

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.8</version>
    <configuration>
        <includes>
            <include>com/igot/cb/*</include>
            <include>com/igot/cb/**/*</include>
        </includes>
        <rules>
            <rule>
                <element>BUNDLE</element>
                <limits>
                    <limit>
                        <counter>INSTRUCTION</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.30</minimum>
                    </limit>
                    <limit>
                        <counter>BRANCH</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.20</minimum>
                    </limit>
                </limits>
            </rule>
        </rules>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
        <execution>
            <id>check</id>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

---



