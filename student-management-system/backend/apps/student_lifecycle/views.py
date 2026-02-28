from rest_framework import viewsets, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Application, Student
from .serializers import ApplicationSerializer, StudentSerializer

class ApplicationViewSet(viewsets.ModelViewSet):
    queryset = Application.objects.all()
    serializer_class = ApplicationSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['status', 'applying_for_class']
    search_fields = ['first_name', 'last_name', 'application_id']

class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['status', 'current_class']
    search_fields = ['first_name', 'last_name', 'student_id']
