from django.db import models

class AbstractTableMeta(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True, related_name='+')
    modified_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True, related_name='+')

    class Meta:
        abstract = True
