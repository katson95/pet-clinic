FROM anapsix/alpine-java
LABEL maintainer="katson95@gmail.com"
COPY /target/pet-clinic-2.1.0.BUILD-SNAPSHOT.jar /home/pet-clinic-2.1.0.BUILD-SNAPSHOT.jar
CMD ["java","-jar","/home/pet-clinic-2.1.0.BUILD-SNAPSHOT.jar"]
