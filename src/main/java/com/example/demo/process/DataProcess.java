package com.example.demo.process;

import com.example.demo.model.Edge;
import com.example.demo.model.Vertical;
import lombok.Data;
import lombok.Getter;



import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Getter
public class DataProcess {
    private static final String verticalFilePath = "src/main/resources/files/vertical.xlsx";
    private static final String edgeFilePath = "src/main/resources/files/edge.xlsx";
    private final Integer totalVerticalFromFile;
    private final Map<Integer, Vertical> labelMapper = new HashMap<>();
    private final List<Edge> edges = new ArrayList<>();
    public DataProcess() throws IOException {
        for (String edge : ExcelReader.readExcel(edgeFilePath)) {
            String[] temp = edge.split("\\.");
            edges.add(new Edge(Integer.parseInt(temp[0]), Integer.parseInt(temp[1])));
        }
        for (String vertical : ExcelReader.readExcel(verticalFilePath)) {
            String[] temp = vertical.split(",");
            labelMapper.put(Integer.parseInt(temp[0]), new Vertical(Double.parseDouble(temp[1]), Double.parseDouble(temp[2])));
        }
        totalVerticalFromFile=labelMapper.size();
    }
}
