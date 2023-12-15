package org.example.process;

import org.example.model.Vertical;

public class PointInPolygonAlgorithm {
    public static boolean isPointInsidePolygon(Vertical vertical,DataProcess dataProcess ) {
        double[] xPolygon = dataProcess.getXPolygon();
        double[] yPolygon = dataProcess.getYPolygon();
        double xPoint = vertical.getX();
        double yPoint = vertical.getY();
        int vertexCount = xPolygon.length;

        boolean result = false;
        for (int i = 0, j = vertexCount - 1; i < vertexCount; j = i++) {
            if ((yPolygon[i] > yPoint) != (yPolygon[j] > yPoint) &&
                    (xPoint < (xPolygon[j] - xPolygon[i]) * (yPoint - yPolygon[i]) / (yPolygon[j] - yPolygon[i]) + xPolygon[i])) {
                result = !result;
            }
        }

        return result;
    }
}
