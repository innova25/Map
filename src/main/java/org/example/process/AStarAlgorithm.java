package org.example.process;

import org.example.model.Edge;
import org.example.model.Vertical;

import java.util.*;


public class AStarAlgorithm extends Algorithm {
    @Override
    public List<Vertical> solve() {
        int startLabel = getNearestVerticalLabel(getInput().getStart());
        int goalLabel = getNearestVerticalLabel(getInput().getEnd());

        Map<Integer, Double> gScore = new HashMap<>();
        Map<Integer, Double> fScore = new HashMap<>();
        Map<Integer, Integer> cameFrom = new HashMap<>();

        PriorityQueue<Integer> openSet = new PriorityQueue<>(Comparator.comparingDouble(fScore::get));
        Set<Integer> closedSet = new HashSet<>();

        for (int label : getDataProcess().getLabelMapper().keySet()) {
            gScore.put(label, Double.MAX_VALUE);
            fScore.put(label, Double.MAX_VALUE);
        }

        gScore.put(startLabel, 0.0);
        fScore.put(startLabel, calculateHeuristic(startLabel, goalLabel));
        openSet.add(startLabel);

        while (!openSet.isEmpty()) {
            int current = openSet.poll();

            if (current == goalLabel) {
                return reconstructPath(cameFrom, current);
            }

            closedSet.add(current);

            for (Edge edge : getDataProcess().getEdges()) {
                if (edge.getStart().equals(current) && !closedSet.contains(edge.getEnd())) {
                    int neighbor = edge.getEnd();
                    double tentativeGScore = gScore.get(current) + calculateDistance(getDataProcess().getLabelMapper().get(current), getDataProcess().getLabelMapper().get(neighbor));

                    if (tentativeGScore < gScore.get(neighbor)) {
                        cameFrom.put(neighbor, current);
                        gScore.put(neighbor, tentativeGScore);
                        fScore.put(neighbor, tentativeGScore + calculateHeuristic(neighbor, goalLabel));

                        if (!openSet.contains(neighbor)) {
                            openSet.add(neighbor);
                        }
                    }
                }
            }
        }

        return null; // If the goal is not reachable, return null or handle accordingly.
    }

    private List<Vertical> reconstructPath(Map<Integer, Integer> cameFrom, int current) {
        List<Vertical> path = new ArrayList<>();
        path.add(getDataProcess().getLabelMapper().get(current));

        while (cameFrom.containsKey(current)) {
            current = cameFrom.get(current);
            path.add(0, getDataProcess().getLabelMapper().get(current));
        }

        return path;
    }



    private double calculateHeuristic(int startLabel, int goalLabel) {
        Vertical start = getDataProcess().getLabelMapper().get(startLabel);
        Vertical goal = getDataProcess().getLabelMapper().get(goalLabel);
        return calculateDistance(start, goal);
    }
}
