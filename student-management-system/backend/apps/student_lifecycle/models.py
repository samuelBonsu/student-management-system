from django.db import models
from django.contrib.auth import get_user_model
from apps.utils.models import AbstractTableMeta

User = get_user_model()

class Application(AbstractTableMeta, models.Model):
    APPLICATION_STATUS = (
        ('draft', 'Draft'),
        ('submitted', 'Submitted'),
        ('under_review', 'Under Review'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
    )
    
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    date_of_birth = models.DateField()
    application_id = models.CharField(max_length=50, unique=True)
    applying_for_class = models.CharField(max_length=50)
    status = models.CharField(max_length=30, choices=APPLICATION_STATUS, default='draft')
    
    parent_first_name = models.CharField(max_length=100)
    parent_last_name = models.CharField(max_length=100)
    parent_phone = models.CharField(max_length=20)
    parent_email = models.EmailField()
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.application_id} - {self.first_name} {self.last_name}"

class Student(AbstractTableMeta, models.Model):
    STUDENT_STATUS = (
        ('enrolled_active', 'Enrolled - Active'),
        ('suspended', 'Suspended'),
        ('transferred', 'Transferred'),
        ('withdrawn', 'Withdrawn'),
        ('graduated', 'Graduated'),
    )
    
    user = models.OneToOneField(User, on_delete=models.SET_NULL, null=True, blank=True)
    application = models.OneToOneField(Application, on_delete=models.SET_NULL, null=True)
    
    student_id = models.CharField(max_length=50, unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    date_of_birth = models.DateField()
    
    current_class = models.CharField(max_length=50)
    enrollment_date = models.DateField(auto_now_add=True)
    status = models.CharField(max_length=30, choices=STUDENT_STATUS, default='enrolled_active')
    
    def __str__(self):
        return f"{self.student_id} - {self.first_name} {self.last_name}"
