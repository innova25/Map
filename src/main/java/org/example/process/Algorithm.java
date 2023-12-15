package org.example.process;

import lombok.Data;
import org.example.model.Input;
import org.example.model.Vertical;

import java.util.List;
import java.util.Map;
@Data
public abstract class Algorithm {
    private DataProcess dataProcess;
    private Input input;
    int getNearestVerticalLabel(Vertical point) {
        int nearestLabel = -1;
        double minDistance = Double.MAX_VALUE;

        for (Map.Entry<Integer, Vertical> entry : dataProcess.getLabelMapper().entrySet()) {
            double distance = calculateDistance(point, entry.getValue());

            if (distance < minDistance) {
                minDistance = distance;
                nearestLabel = entry.getKey();
            }
        }

        return nearestLabel;
    }
    double calculateDistance(Vertical start, Vertical end) {
        return Math.sqrt(Math.pow(end.getX() - start.getX(), 2) + Math.pow(end.getY() - start.getY(), 2));
    }

   public abstract List<Vertical> solve();
}
