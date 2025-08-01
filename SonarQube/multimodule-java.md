# Code Coverage Plugin Setup for multimodule java service

This document outlines the plugins required for enabling test execution and code coverage reporting across different types of submodules.

---

## ✅ Java Submodule (`pom.xml`)
Use **JaCoCo** and **Surefire** for code coverage and test execution.

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.1.2</version>
    </plugin>

    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.8</version>
      <configuration>
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
  </plugins>
</build>
```

---

## ✅ Scala Submodule (`pom.xml`)
Use **Scoverage**, **ScalaTest Plugin**, and **Scala Maven Plugin**.

```xml
<properties>
  <scoverage.plugin.version>1.4.1</scoverage.plugin.version>
</properties>

<build>
  <sourceDirectory>src/main/scala</sourceDirectory>
  <testSourceDirectory>src/test/scala</testSourceDirectory>
  <plugins>
    <plugin>
      <groupId>net.alchim31.maven</groupId>
      <artifactId>scala-maven-plugin</artifactId>
      <version>4.4.0</version>
      <configuration>
        <scalaVersion>${scala.version}</scalaVersion>
        <checkMultipleScalaVersions>false</checkMultipleScalaVersions>
      </configuration>
      <executions>
        <execution>
          <id>scala-compile-first</id>
          <phase>process-resources</phase>
          <goals>
            <goal>add-source</goal>
            <goal>compile</goal>
          </goals>
        </execution>
        <execution>
          <id>scala-test-compile</id>
          <phase>process-test-resources</phase>
          <goals>
            <goal>testCompile</goal>
          </goals>
        </execution>
      </executions>
    </plugin>

    <plugin>
      <groupId>org.scalatest</groupId>
      <artifactId>scalatest-maven-plugin</artifactId>
      <version>2.0.0</version>
      <executions>
        <execution>
          <id>scalatest</id>
          <phase>verify</phase>
          <goals>
            <goal>test</goal>
          </goals>
        </execution>
      </executions>
    </plugin>

    <plugin>
      <groupId>org.scoverage</groupId>
      <artifactId>scoverage-maven-plugin</artifactId>
      <version>${scoverage.plugin.version}</version>
      <configuration>
        <scalaVersion>${scala.version}</scalaVersion>
        <aggregate>true</aggregate>
        <highlighting>true</highlighting>
      </configuration>
    </plugin>
  </plugins>
</build>
```

---

## ✅ Scala + Play2 Submodule (`pom.xml`)
Use same plugins as Scala submodule, plus **Play2 Maven Plugin**.

```xml
<plugin>
  <groupId>com.google.code.play2-maven-plugin</groupId>
  <artifactId>play2-maven-plugin</artifactId>
  <version>1.0.0-rc5</version>
  <extensions>true</extensions>
  <configuration>
    <routesGenerator>static</routesGenerator>
  </configuration>
</plugin>
```

Include this alongside ScalaTest, Scala plugin, and Scoverage plugins as shown in the previous section.

---

## ✅ Parent POM (`certificate-generator-service/pom.xml`)

Ensure the following configurations are present for consistent version management:

```xml
<properties>
  <scala.version>2.13.12</scala.version>
  <scala.major.version>2.13</scala.major.version>
  <scoverage.plugin.version>1.4.1</scoverage.plugin.version>
  <jacoco.version>0.8.8</jacoco.version>
  <maven.compiler.source>1.8</maven.compiler.source>
  <maven.compiler.target>1.8</maven.compiler.target>
</properties>
```

