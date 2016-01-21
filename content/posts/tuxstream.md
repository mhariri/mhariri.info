+++
date = "2010-12-01T21:49:10+01:00"
draft = false
description = "My master's thesis"
keywords = ["tuxstream", "peer to peer", "p2p", "live media streaming", "Locality-awareness", "Push-pull solution"]
title = "TuxStream: A Locality-Aware Hybrid Tree/Mesh Overlay For Peer-to-Peer Live Media Streaming"
type = "post"
+++

[Download the full document](tuxstream.pdf)

##### Abstract
Peer-to-peer (P2P) live media streaming has become widely popular in today’s
Internet. A lot of research has been done in the topic of streaming video to a
large population of users in recent years, but it is still a challenging problem.
Users must receive data simultaneously with minimal delay. Peer-to-peer systems
introduce a new challenges: nodes can join and leave continuously and
concurrently. Therefore, a solution is needed that is robust to node dynamics.
Also, load of distributing data must be balanced among users so the bandwidth
of all participating nodes is used. On the other hand, retrieving data
chunks from the proximity neighborhood of the nodes leads to more efficient
use of network resources.

In this thesis we present tuxStream, a hybrid mesh/tree solution addressing
above problems. To achieve fast distribution of data, a tree of nodes that
have stayed in the system for a sufficient period of time with high upload
bandwidth is gradually formed. Further, we organize nodes in proximity-aware
groups and from a mesh structure of nodes in each group. This way
nodes are able to fetch data from neighbors in their locality. Each group
has a tree node as its member that disseminates new data chunks in the
group. To guarantee resiliency to node dynamics, an auxiliary mesh structure
is constructed of all nodes in the system. If a fluctuation in data delivery
happens or a tree node fails, nodes are able to get data from their neighbors
in this auxiliary mesh structure. We evaluate the performance of our system
to show the effect of locality-aware neighbor selection on network traffic. In
addition we compare it with mTreebone, a hybrid tree/mesh overlay, and
CoolStreaming, a pure mesh based solution, and show that tuxStream has
better load distribution and lower network traffic while maintaining playback
continuity and low transmission delays.
