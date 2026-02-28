from rest_framework import serializers
from .models import Application, Student

class ApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Application
        fields = '__all__'
        read_only_fields = ('application_id', 'created_at', 'updated_at')

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'
        read_only_fields = ('student_id', 'enrollment_date', 'created_at', 'updated_at')
