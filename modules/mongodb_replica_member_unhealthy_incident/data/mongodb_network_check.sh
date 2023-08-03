if ping -c 3 $PRIMARY && ping -c 3 $SECONDARY && ping -c 3 $ARBITER; then

    echo "Network connectivity between MongoDB replica members is OK"

else

    echo "Network connectivity between MongoDB replica members is not OK"

    # Restart network service to resolve the issue

    service network restart

    echo "Network service restarted"

fi