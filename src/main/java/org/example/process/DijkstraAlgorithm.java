package org.example.process;

import org.example.model.Edge;
import org.example.model.Vertical;

import java.util.*;

public class DijkstraAlgorithm extends Algorithm {
    @Override
    public List<Vertical> solve() {
        int startLabel = getNearestVerticalLabel(getInput().getStart());
        int goalLabel = getNearestVerticalLabel(getInput().getEnd());
        Map<Integer, Double> distance = new HashMap<>();
        Map<Integer, Integer> previous = new HashMap<>();
        PriorityQueue<Integer> queue = new PriorityQueue<>(Comparator.comparingDouble(distance::get));

        for (int label : getDataProcess().getLabelMapper().keySet()) {
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

            for (Edge edge :getDataProcess().getEdges()) {
                if (edge.getStart().equals(current)) {
                    try {

                        int neighbor = edge.getEnd();
                        double newDistance = distance.get(current) + calculateDistance(getDataProcess().getLabelMapper().get(current), getDataProcess().getLabelMapper().get(neighbor));


                    if (newDistance < distance.get(neighbor)) {
                        distance.put(neighbor, newDistance);
                        previous.put(neighbor, current);
                        queue.add(neighbor);

                    }
                    } catch (NullPointerException e){
                        System.out.println(edge.getStart());
                        System.out.println(edge.getEnd());
                        System.out.println(current);
                    }
                }
            }
        }
        return null;
    }

    private List<Vertical> reconstructPath(Map<Integer, Integer> previous, int current) {
        List<Vertical> path = new ArrayList<>();
        path.add(getDataProcess().getLabelMapper().get(current));

        while (previous.get(current) != null) {
            current = previous.get(current);
            path.add(0, getDataProcess().getLabelMapper().get(current));
        }

        return path;
    }
}
