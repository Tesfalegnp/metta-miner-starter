; Simple symbolic queue as nested QueueCons/QueueNil
(QueueNil)
(QueueCons a (QueueCons b (QueueCons c QueueNil)))

(= (front-queue (QueueCons $x $xs)) $x)
