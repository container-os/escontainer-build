[escore-extras]
name=ESCore-7 - extras
enabled=1
gpgcheck=0
exclude=python-docker-py

{% if PROD is defined %}
baseurl=http://mirror.easystack.io/ESCL/{{ ESCLOUD_VER }}/extras/x86_64/
username=escore
password=escore
{% else %}
baseurl=http://mirror.easystack.io/mash/escl{{ ES_MAJOR_VER }}{{ ES_MINOR_VER }}-extras/x86_64/
username=easystack
password=passw0rd
{% endif %}
