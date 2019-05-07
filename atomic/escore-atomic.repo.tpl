[escore-atomic]
name=ESCore-7 - atomic
enabled=1
gpgcheck=0
exclude=busybox

{% if PROD is defined %}
baseurl=http://mirror.easystack.io/ESCL/{{ ESCLOUD_VER }}/atomic/x86_64/
username=escore
password=escore
{% else %}
baseurl=http://mirror.easystack.io/mash/escl{{ ES_MAJOR_VER }}{{ ES_MINOR_VER }}-atomic/x86_64/
username=easystack
password=passw0rd
{% endif %}
