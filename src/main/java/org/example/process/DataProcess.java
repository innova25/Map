package org.example.process;


import lombok.Getter;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.example.model.Edge;
import org.example.model.Vertical;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
public class DataProcess {
    private static final String verticalFilePath = "src/main/resources/files/markers.xlsx";
    private static final String edgeFilePath = "src/main/resources/files/edges.xlsx";
    private static final String outlineFilePath = "src/main/resources/files/outline.xlsx";
    private final Map<Integer, Vertical> labelMapper = new HashMap<>();
    private final List<Edge> edges = new ArrayList<>();
    private final List<Vertical> outline = new ArrayList<>();


    public DataProcess() throws IOException {
        readVertical();
        readEdges();
        readOutline();
    }

    private void readVertical() throws IOException {
        FileInputStream fileInputStream = new FileInputStream(verticalFilePath);
        try (Workbook workbook = new XSSFWorkbook(fileInputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                Integer label = null;
                Double lat = null;
                Double lng = null;
                for (Cell cell : row) {
                    String cellValue = cell.toString();
                    if (label == null) {
                        label = (int) Double.parseDouble(cellValue);
                        continue;
                    }
                    if (lat == null) {
                        lat = Double.parseDouble(cellValue);
                        continue;
                    }
                    if (lng == null) {
                        lng = Double.parseDouble(cellValue);
                    }
                }
                labelMapper.put(label, new Vertical(lat, lng));
            }
        }
        fileInputStream.close();
    }

    private void readEdges() throws IOException {
        FileInputStream fileInputStream = new FileInputStream(edgeFilePath);
        try (Workbook workbook = new XSSFWorkbook(fileInputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                Integer fromLabel = null;
                Integer toLabel = null;
                for (Cell cell : row) {
                    String cellValue = cell.toString();
                    if (fromLabel == null) {
                        fromLabel = (int) Double.parseDouble(cellValue);
                        continue;
                    }
                    if (toLabel == null) {
                        toLabel = (int) Double.parseDouble(cellValue);
                    }
                }
                edges.add(new Edge(fromLabel, toLabel));
            }
        }
        fileInputStream.close();
    }

    private void readOutline() throws IOException {
        FileInputStream fileInputStream = new FileInputStream(outlineFilePath);
        try (Workbook workbook = new XSSFWorkbook(fileInputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                for (Cell cell : row) {
                    String cellValue = cell.toString();
                    String[] data = cellValue.split(", ");
                    outline.add(new Vertical(Double.parseDouble(data[0]), Double.parseDouble(data[1])));
                }
            }
        }
        fileInputStream.close();
    }
}
