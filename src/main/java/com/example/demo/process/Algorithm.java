package com.example.demo.process;

import com.example.demo.model.Edge;
import com.example.demo.model.Input;
import com.example.demo.model.Vertical;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


import java.util.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Algorithm {
    DataProcess dataProcess;
    Input input;
    public List<Vertical> solve() {
        int startLabel = getNearestVerticalLabel(input.getStart());
        int goalLabel = getNearestVerticalLabel(input.getEnd());

        Map<Integer, Double> distance = new HashMap<>();
        Map<Integer, Integer> previous = new HashMap<>();
        PriorityQueue<Integer> queue = new PriorityQueue<>(Comparator.comparingDouble(distance::get));

        for (int label : dataProcess.getLabelMapper().keySet()) {
            distance.put(label, Double.MAX_VALUE);
            previous.put(label, null);
        }

        distance.put(startLabel, 0.0);
        queue.add(startLabel);

        while (!queue.isEmpty()) {
            int current = queue.poll();

            if (current == goalLabel) {
                return reconstructPath(previous, current);
            }

            for (Edge edge : dataProcess.getEdges()) {
                if (edge.getStart().equals(current)) {
                    int neighbor = edge.getEnd();
                    double newDistance = distance.get(current) + calculateDistance(dataProcess.getLabelMapper().get(current), dataProcess.getLabelMapper().get(neighbor));

                    if (newDistance < distance.get(neighbor)) {
                        distance.put(neighbor, newDistance);
                        previous.put(neighbor, current);
                        queue.add(neighbor);
                    }
                }
            }
        }

        return null; // If the goal is not reachable, return null or handle accordingly.
    }

    private List<Vertical> reconstructPath(Map<Integer, Integer> previous, int current) {
        List<Vertical> path = new ArrayList<>();
        path.add(dataProcess.getLabelMapper().get(current));

        while (previous.get(current) != null) {
            current = previous.get(current);
            path.add(0, dataProcess.getLabelMapper().get(current));
        }

        return path;
    }

    public int getNearestVerticalLabel(Vertical point) {
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

    private double calculateDistance(Vertical start, Vertical end) {
        return Math.sqrt(Math.pow(end.getX()-start.getX(), 2) + Math.pow(end.getY() - start.getY(), 2));
    }
}
