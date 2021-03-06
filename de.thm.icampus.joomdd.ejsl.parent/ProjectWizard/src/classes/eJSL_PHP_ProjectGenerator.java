package classes;

import com.intellij.ide.util.projectWizard.WebProjectTemplate;
import com.intellij.openapi.fileEditor.FileEditorManager;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.IconLoader;
import com.intellij.openapi.vfs.LocalFileSystem;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.platform.ProjectGeneratorPeer;
import com.intellij.util.PathUtil;
import org.jetbrains.annotations.Nls;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;
import java.io.*;
import java.util.HashMap;
import java.util.Properties;

/**
 * Created by Max on 09.03.2016.
 */
public class eJSL_PHP_ProjectGenerator extends WebProjectTemplate {

    public Icon getIcon()
    {
        return IconLoader.getIcon("/icons/eJSL.PNG");
    }

    public Icon getLogo() {
        return IconLoader.getIcon("/icons/eJSL.PNG");
    }

    @Nls
    @NotNull
    @Override
    public String getName() {
        return "eJSL";
    }

    @Override
    public String getDescription() {
        return "Description eJSL";
    }

    @Override
    public void generateProject(@NotNull Project project, @NotNull VirtualFile virtualFile, @NotNull Object o, @NotNull Module module) {

        try {
            File projectFile = new File(project.getBasePath() + "/.idea/" + project.getName() + ".iml");
            StringBuilder projectConfig = new StringBuilder();

            InputStream fileIS = this.getClass().getClassLoader().getResourceAsStream("settings/php_projectfile.xml");
            BufferedReader br =  new BufferedReader(new InputStreamReader(fileIS, "UTF-8"));
            
            String buffer = "";
            while ((buffer = br.readLine()) != null) {
                projectConfig.append((buffer + "\n"));
            }

            projectFile.createNewFile();
            FileWriter fw = new FileWriter(project.getBasePath() + "/.idea/" + project.getName() + ".iml");
            BufferedWriter bw = new BufferedWriter(fw);

            bw.write(projectConfig.toString());

            br.close();
            bw.close();
            fw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        File src = new File(project.getBasePath() + "/src");
        File src_gen = new File(project.getBasePath() + "/src-gen");
        File model = new File(project.getBasePath() + "/src/Model.eJSL");

        StringBuilder example = new StringBuilder();

        try {
            src.mkdir();
            src_gen.mkdir();
            FileWriter fw = new FileWriter(project.getBasePath() + "/src/Model.eJSL");

            InputStream fileIS = this.getClass().getClassLoader().getResourceAsStream("templates/"+eJSL_PHP_Wizard_Step.getOption());
            BufferedReader br =  new BufferedReader(new InputStreamReader(fileIS, "UTF-8"));
            
            String buffer = "";
            while ((buffer = br.readLine()) != null) {
                example.append((buffer + "\n"));
            }

            model.createNewFile();
            BufferedWriter bw = new BufferedWriter(fw);

            Properties config = new Properties();
            HashMap<String, String> genproperties = eJSL_PHP_Wizard_Step.getGereratorProperties();
            config.putAll(genproperties);
            config.setProperty("outputFolder", src_gen.getPath());
            FileWriter configWriter = new FileWriter(project.getBasePath() + "/generator.properties");
            config.store(configWriter, "Generator configuration");

            bw.write(example.toString());

            br.close();
            bw.close();
            fw.close();
            configWriter.close();

            project.getBaseDir().refresh(false,true);

            FileEditorManager fileEditorManager = FileEditorManager.getInstance(project);
            VirtualFile vf = LocalFileSystem.getInstance().findFileByPath(project.getBasePath()+"/src/Model.eJSL");
            fileEditorManager.openFile(vf, true, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @NotNull
    @Override
    public ProjectGeneratorPeer<Object> createPeer() {
        return new eJSL_PHP_Wizard_Step();
    }
}
