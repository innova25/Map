package org.example.process;

import lombok.AllArgsConstructor;
import org.example.model.Input;
import org.example.model.Vertical;
@AllArgsConstructor
public class OutPut {


    public static String getResult(Input input, DataProcess dataProcess, AlgorithmName algorithmName){
        StringBuilder outPut = new StringBuilder();
        Algorithm algorithm = null;
        switch (algorithmName) {
            case DIJKSTRA -> algorithm = new DijkstraAlgorithm();
            case A_STAR -> algorithm = new AStarAlgorithm();
        }
        algorithm.setDataProcess(dataProcess);
        algorithm.setInput(input);


        for(Vertical vertical: algorithm.solve()){
            outPut.append(vertical.getX()).append(",").append(vertical.getY()).append("|");
        }
        outPut = new StringBuilder(outPut.substring(0, outPut.length() - 1));
        return outPut.toString();
    }
}
