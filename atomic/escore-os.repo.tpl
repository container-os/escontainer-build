[escore-os]
name=ESCore-7 - os
{% if PROD is defined %}
baseurl=http://mirror.easystack.cn/ESCL/{{ ESCLOUD_VER }}/os/x86_64/
username=escore
password=escore
{% else %}
baseurl=http://mirror.easystack.cn/mash/escl{{ ES_MAJOR_VER }}{{ ES_MINOR_VER }}-os/x86_64/
username=easystack
password=passw0rd
{% endif %}
enabled=1
gpgcheck=0
