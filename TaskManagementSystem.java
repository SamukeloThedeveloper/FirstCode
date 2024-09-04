import java.io.*;
import java.util.*;

class Task implements Serializable {
    private String title;
    private String description;
    private boolean completed;

    public Task(String title, String description) {
        this.title = title;
        this.description = description;
        this.completed = false;
    }

    public String getTitle() {
        return title;
    }

    public void markAsCompleted() {
        this.completed = true;
    }

    @Override  
    public String toString() {
        return "Task: " + title + "\nDescription: " + description + "\nCompleted: " + completed;
    }
}

class TaskManager {
    private static TaskManager instance;
    private List<Task> tasks;

    private TaskManager() {
        tasks = new ArrayList<>();
    }

    public static TaskManager getInstance() {
        if (instance == null) {
            instance = new TaskManager();
        }
        return instance;
    }

    public void addTask(Task task) {
        tasks.add(task);
    }

    public void markTaskAsCompleted(String title) {
        for (Task task : tasks) {
            if (task.getTitle().equalsIgnoreCase(title)) {
                task.markAsCompleted();
                break;
            }
        }
    }

    public void saveTasksToFile(String filename) throws IOException {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
            oos.writeObject(tasks);
        }
    }

    public void loadTasksFromFile(String filename) throws IOException, ClassNotFoundException {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
            tasks = (List<Task>) ois.readObject();
        }
    }

    public void listTasks() {
        tasks.forEach(System.out::println);
    }
}

public class TaskManagementSystem {

    public static void main(String[] args) {
        TaskManager taskManager = TaskManager.getInstance();

        Task task1 = new Task("Implement Feature X", "Develop the new feature for the application.");
        Task task2 = new Task("Fix Bug Y", "Resolve the critical bug affecting production.");

        taskManager.addTask(task1);
        taskManager.addTask(task2);

        taskManager.markTaskAsCompleted("Implement Feature X");

        taskManager.listTasks();

        try {
            taskManager.saveTasksToFile("tasks.dat");
            taskManager.loadTasksFromFile("tasks.dat");
            taskManager.listTasks();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
