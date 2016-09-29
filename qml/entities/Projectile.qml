import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: projectile
    entityId: "entity"
    entityType: "projectile"

    width: 5
    height: 10

    property real speed: 5000

    property real damage: 5

    Component.onCompleted: {
        applyForwardImpuls()
    }

    Image{
        anchors.fill: parent
        source: "../../assets/projectile.png"
    }

    BoxCollider{
        id: collider
        anchors.fill: parent

        density: 0.1
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0

        bullet: true

        fixture.onBeginContact:{
            var fixture = other
            var body = other.getBody()
            var otherEntity = body.target

            var collidingType = otherEntity.entityType

            if (collidingType === "asteroid")
            {
                var health = otherEntity.getComponent("health")

                if (health !== "unfined")
                    health.applyDamage(damage)
            }
            projectile.removeEntity()
            return
        }
    }

    function applyForwardImpuls() {
        var rad = projectile.rotation / 180 * Math.PI

        var localForward = Qt.point(projectile.speed * Math.sin(rad), -projectile.speed * Math.cos(rad))
        collider.body.applyLinearImpulse(localForward, collider.body.getWorldCenter())
    }
}
