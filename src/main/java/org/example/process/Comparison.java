package org.example.process;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.example.model.Input;

@Data
@AllArgsConstructor
public class Comparison {
   private  Input input;
   private DataProcess dataProcess;
   private AlgorithmName algorithmName;

   public void getResult(){
      Algorithm algorithm = null;
      long startTime;
      long endTime;
      String out = "";
      switch (algorithmName) {
         case DIJKSTRA ->{
            algorithm = new DijkstraAlgorithm();
            out = "Dijkstra: ";
         }
         case A_STAR -> {
            algorithm = new AStarAlgorithm();
            out ="A*: ";
         }
      }
      algorithm.setDataProcess(dataProcess);
      algorithm.setInput(input);


      startTime = System.currentTimeMillis();
      algorithm.solve();
      endTime = System.currentTimeMillis();
      System.out.println(out +(endTime-startTime));


   }
}
