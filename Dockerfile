FROM ct2034/vnc-ros-kinetic-full

RUN apt-get update
RUN rm -rf /var/lib/apt/list/*

# Install ROS-Industrial + universal robot
RUN apt-get install -y --no-install-recommends ros-kinetic-industrial-core \
    && apt-get install -y --no-install-recommends ros-kinetic-universal-robot

# Install OpenIGTLink under /root/igtl
RUN mkdir igtl \
    && cd igtl \
    && git clone https://github.com/openigtlink/OpenIGTLink \
    && mkdir OpenIGTLink-build \
    && cd OpenIGTLink-build \
    && cmake -DBUILD_SHARED_LIBS:BOOL=ON -DBUILD_EXAMPLES:BOOL=ON ../OpenIGTLink \
    && make

# Setup ROS-IGTL-Bridge
RUN mkdir -p /root/catkin_ws/src \
    && cd /root/catkin_ws \
    && /bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin_make" \
    && cd /root/catkin_ws/src \
    && git clone https://github.com/openigtlink/ROS-IGTL-Bridge \
    && cd /root/catkin_ws \
    && /bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin_make --cmake-args -DOpenIGTLink_DIR:PATH=/root/igtl/OpenIGTLink-build"

    

