[escore-os]
name=ESCore-7 - os
{% if PROD is defined %}
baseurl=http://mirror.easystack.io/ESCL/{{ ESCLOUD_VER }}/os/x86_64/
username=escore
password=escore
{% else %}
baseurl=http://mirror.easystack.io/mash/escl{{ ES_MAJOR_VER }}{{ ES_MINOR_VER }}-os/x86_64/
username=easystack
password=passw0rd
{% endif %}
enabled=1
gpgcheck=0
