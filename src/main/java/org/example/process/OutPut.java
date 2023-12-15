package org.example.process;

import lombok.AllArgsConstructor;
import org.example.model.Input;
import org.example.model.Vertical;
@AllArgsConstructor
public class OutPut {
    private Input input;
    private DataProcess dataProcess;
    private AlgorithmName algorithmName;

    public String getResult(){
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
        System.out.println(outPut);
        return outPut.toString();
    }
}
