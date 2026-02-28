# setup_complete_postgres.ps1
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SMS ERPCore - Complete Setup with PostgreSQL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop any running Django servers
Write-Host "Stopping any running Django servers..." -ForegroundColor Yellow
Get-Process -Name "python" -ErrorAction SilentlyContinue | Stop-Process -Force

# Clean up existing structure
Write-Host "Cleaning up old files..." -ForegroundColor Red
Remove-Item -Path "backend" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "apps" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "config" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "manage.py" -Force -ErrorAction SilentlyContinue

Write-Host "Creating fresh project structure..." -ForegroundColor Green

# Create new directory structure
New-Item -Path "backend" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\config" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\student_lifecycle" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\student_lifecycle\migrations" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\users" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\users\migrations" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\utils" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\utils\migrations" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\core" -ItemType Directory -Force | Out-Null
New-Item -Path "backend\apps\core\migrations" -ItemType Directory -Force | Out-Null
New-Item -Path "frontend" -ItemType Directory -Force | Out-Null

# Create __init__.py files
New-Item -Path "backend\apps\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\student_lifecycle\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\student_lifecycle\migrations\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\users\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\users\migrations\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\utils\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\utils\migrations\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\core\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\apps\core\migrations\__init__.py" -ItemType File -Force | Out-Null
New-Item -Path "backend\config\__init__.py" -ItemType File -Force | Out-Null

# Create manage.py
Write-Host "Creating manage.py..." -ForegroundColor Yellow
$managePyContent = @"
#!/usr/bin/env python
import os
import sys

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed?"
        ) from exc
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
"@
Set-Content -Path "backend\manage.py" -Value $managePyContent -Force

# Create requirements.txt (added psycopg2 for PostgreSQL)
Write-Host "Creating requirements.txt..." -ForegroundColor Yellow
$requirementsContent = @"
Django==3.2.20
djangorestframework==3.14.0
django-cors-headers==4.0.0
django-debug-toolbar==4.1.0
django-filter==23.2
psycopg2-binary==2.9.7
Pillow==10.0.0
django-oauth-toolkit==2.3.0
social-auth-app-django==5.2.0
"@
Set-Content -Path "backend\requirements.txt" -Value $requirementsContent -Force

# Create settings.py with PostgreSQL configuration
Write-Host "Creating settings.py with PostgreSQL..." -ForegroundColor Yellow
$settingsContent = @"
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'django-insecure-your-secret-key-here-change-in-production'
DEBUG = True
ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third party
    'rest_framework',
    'rest_framework.authtoken',
    'corsheaders',
    'debug_toolbar',
    'django_filters',
    
    # Local apps
    'apps.utils',
    'apps.users',
    'apps.core',
    'apps.student_lifecycle',
]

MIDDLEWARE = [
    'debug_toolbar.middleware.DebugToolbarMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

# PostgreSQL Database Configuration
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'freecodeschool',        # Your database name
        'USER': 'fcs_admin',              # Your PostgreSQL username
        'PASSWORD': 'admin123',            # Your PostgreSQL password
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

STATIC_URL = '/static/'
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AUTH_USER_MODEL = 'users.User'

CORS_ALLOW_ALL_ORIGINS = True

INTERNAL_IPS = ['127.0.0.1']

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.TokenAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
    ],
}
"@
Set-Content -Path "backend\config\settings.py" -Value $settingsContent -Force

# Create urls.py
$urlsContent = @"
from django.contrib import admin
from django.urls import path, include
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/users/', include('apps.users.urls')),
    path('api/v1/student-lifecycle/', include('apps.student_lifecycle.urls')),
    path('api/v1/core/', include('apps.core.urls')),
]

if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [path('__debug__/', include(debug_toolbar.urls))] + urlpatterns
"@
Set-Content -Path "backend\config\urls.py" -Value $urlsContent -Force

# Create wsgi.py
$wsgiContent = @"
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
application = get_wsgi_application()
"@
Set-Content -Path "backend\config\wsgi.py" -Value $wsgiContent -Force

# Create asgi.py
$asgiContent = @"
import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
application = get_asgi_application()
"@
Set-Content -Path "backend\config\asgi.py" -Value $asgiContent -Force

# Create utils/models.py
$utilsModelsContent = @"
from django.db import models

class AbstractTableMeta(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True, related_name='+')
    modified_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True, related_name='+')

    class Meta:
        abstract = True
"@
Set-Content -Path "backend\apps\utils\models.py" -Value $utilsModelsContent -Force

# Create users/models.py
$usersModelsContent = @"
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    USER_TYPE_CHOICES = (
        ('student', 'Student'),
        ('teacher', 'Teacher'),
        ('parent', 'Parent'),
        ('admin', 'Admin'),
        ('accountant', 'Accountant'),
        ('principal', 'Principal'),
    )
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES, default='student')
    
    def __str__(self):
        return self.email or self.username
"@
Set-Content -Path "backend\apps\users\models.py" -Value $usersModelsContent -Force

# Create users/urls.py
$usersUrlsContent = @"
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('login/', obtain_auth_token, name='api_token_auth'),
]
"@
Set-Content -Path "backend\apps\users\urls.py" -Value $usersUrlsContent -Force

# Create users/admin.py
$usersAdminContent = @"
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'user_type', 'is_staff')
    list_filter = ('user_type', 'is_staff', 'is_superuser')
    fieldsets = UserAdmin.fieldsets + (
        ('User Type', {'fields': ('user_type',)}),
    )
"@
Set-Content -Path "backend\apps\users\admin.py" -Value $usersAdminContent -Force

# Create core/urls.py
$coreUrlsContent = @"
from django.urls import path
from . import views

urlpatterns = [
    path('health/', views.health_check, name='health_check'),
]
"@
Set-Content -Path "backend\apps\core\urls.py" -Value $coreUrlsContent -Force

# Create core/views.py
$coreViewsContent = @"
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    return Response({
        'status': 'healthy',
        'message': 'SMS ERPCore API is running',
        'version': '1.0.0'
    })
"@
Set-Content -Path "backend\apps\core\views.py" -Value $coreViewsContent -Force

# Add student_lifecycle models.py (simplified version)
$studentModelsContent = @"
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
"@
Set-Content -Path "backend\apps\student_lifecycle\models.py" -Value $studentModelsContent -Force

# Add student_lifecycle admin.py
$studentAdminContent = @"
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
"@
Set-Content -Path "backend\apps\student_lifecycle\admin.py" -Value $studentAdminContent -Force

# Add student_lifecycle serializers.py
$studentSerializersContent = @"
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
"@
Set-Content -Path "backend\apps\student_lifecycle\serializers.py" -Value $studentSerializersContent -Force

# Add student_lifecycle views.py
$studentViewsContent = @"
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
"@
Set-Content -Path "backend\apps\student_lifecycle\views.py" -Value $studentViewsContent -Force

# Add student_lifecycle urls.py
$studentUrlsContent = @"
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'applications', views.ApplicationViewSet)
router.register(r'students', views.StudentViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
"@
Set-Content -Path "backend\apps\student_lifecycle\urls.py" -Value $studentUrlsContent -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Project structure created successfully!" -ForegroundColor Green
Write-Host "✅ Using PostgreSQL database: freecodeschool" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. cd backend" -ForegroundColor Yellow
Write-Host "2. pip install -r requirements.txt" -ForegroundColor Yellow
Write-Host "3. python manage.py makemigrations" -ForegroundColor Yellow
Write-Host "4. python manage.py migrate" -ForegroundColor Yellow
Write-Host "5. python manage.py createsuperuser" -ForegroundColor Yellow
Write-Host "6. python manage.py runserver" -ForegroundColor Yellow
Write-Host ""
Write-Host "Then visit:" -ForegroundColor Cyan
Write-Host "- http://127.0.0.1:8000/api/v1/student-lifecycle/applications/" -ForegroundColor White
Write-Host "- http://127.0.0.1:8000/admin/" -ForegroundColor White
