package com.gary.service;

import com.gary.dto.Course;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CourseService {
    private final List<Course> courses = new ArrayList<>();

    public void addCourse(Course course) {
        courses.add(course);
    }

    public List<Course> getAllCourses() {
        return courses;
    }

    public Optional<Course> getCourseById(int id) {
        return courses.stream()
                .filter(course -> course.getId() == id)
                .findFirst();
    }

    public boolean updateCourse(int id, Course course) {
        Optional<Course> existingCourse = getCourseById(id);
        return existingCourse.map(value -> updateCourse(id, course)).orElse(false);
    }

    public boolean deleteCourse(int id) {
        return courses.removeIf(course -> course.getId() == id);
    }
}