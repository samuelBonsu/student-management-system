from django.contrib import admin
from .models import Application, Student

@admin.register(Application)
class ApplicationAdmin(admin.ModelAdmin):
    list_display = ('application_id', 'first_name', 'last_name', 'applying_for_class', 'status')
    list_filter = ('status', 'applying_for_class')
    search_fields = ('first_name', 'last_name', 'application_id')

@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ('student_id', 'first_name', 'last_name', 'current_class', 'status')
    list_filter = ('status', 'current_class')
    search_fields = ('first_name', 'last_name', 'student_id')
