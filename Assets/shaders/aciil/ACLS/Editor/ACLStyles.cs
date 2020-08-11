using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

// Base prepared by Morioh for me.
// This code is based off synqark's arktoon-shaders and Xiexe. 
// Citation to "https://github.com/synqark", "https://github.com/synqark/arktoon-shaders", https://gitlab.com/xMorioh/moriohs-toon-shader.

[InitializeOnLoad]
public class ACLStyles : MonoBehaviour
{
    public static string ver = "ACLS-Shader v" + "<color=#ff0000ff>1.1.1 </color>";
    
    private static Rect DrawShuriken(string title, Vector2 contentOffset, int HeaderHeight)
    {
        var style = new GUIStyle("ShurikenModuleTitle");
        style.font = new GUIStyle(EditorStyles.boldLabel).font;
        style.border = new RectOffset(15, 7, 4, 4);
        style.fixedHeight = HeaderHeight;
        style.contentOffset = contentOffset;
        var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);

        GUI.Box(rect, title, style);
        return rect;
    }

    private static Rect DrawShurikenCenteredTitle(string title, Vector2 contentOffset, int HeaderHeight)
    {
        var style = new GUIStyle("ShurikenModuleTitle");
        style.font = new GUIStyle(EditorStyles.boldLabel).font;
        style.border = new RectOffset(15, 7, 4, 4);
        style.fixedHeight = HeaderHeight;
        style.contentOffset = contentOffset;
        style.alignment = TextAnchor.MiddleCenter;
        var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);

        GUI.Box(rect, title, style);
        return rect;
    }

    public static bool ShurikenFoldout(string title, bool display)
    {
        var rect = DrawShuriken(title, new Vector2(20f, -2f), 22);
        var e = Event.current;
        var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
        if (e.type == EventType.Repaint)
        {
            EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
        }
        if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
        {
            display = !display;
            e.Use();
        }
        return display;
    }

    //parting line text
    private static Rect DrawShurikenPartingLineText(string title, Vector2 contentOffset, int HeaderHeight)
    {
        var style = new GUIStyle("ShurikenModuleTitle");
        style.font = new GUIStyle(EditorStyles.boldLabel).font;
        style.border = new RectOffset(15, 7, 4, 4);
        style.fixedHeight = HeaderHeight;
        style.contentOffset = contentOffset;
        style.alignment = TextAnchor.MiddleCenter;
        var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);

        GUI.Box(rect, title, style);
        return rect;
    }
    //end of parting line text

    //parting lines
    static public void PartingLine()
    {
        GUILayout.Space(5);
        GUILine(new Color(1f, 1f, 1f), 1.5f);
        GUILayout.Space(5);
    }

    static public void GUILine(float height = 0f)
    {
        GUILine(Color.black, height);
    }

    static public void GUILine(Color color, float height = 0f)
    {
        Rect position = GUILayoutUtility.GetRect(0f, float.MaxValue, height, height, LineStyle);

        if (Event.current.type == EventType.Repaint)
        {
            Color orgColor = GUI.color;
            GUI.color = orgColor * color;
            LineStyle.Draw(position, false, false, false, false);
            GUI.color = orgColor;
        }
    }

    static public GUIStyle _LineStyle;
    static public GUIStyle LineStyle
    {
        get
        {
            if (_LineStyle == null)
            {
                _LineStyle = new GUIStyle();
                _LineStyle.normal.background = EditorGUIUtility.whiteTexture;
                _LineStyle.stretchWidth = true;
            }

            return _LineStyle;
        }
    }
    // end of parting line
    //exrta buttons
    public static void gitVersionCheckButton(int Width, int Height)
    {
        if (GUILayout.Button("Check Version", GUILayout.Width(Width), GUILayout.Height(Height)))
        {
            Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/releases");
        }
    }

    public static void gitSourcebutton(int Width, int Height)
    {
        if (GUILayout.Button("Get Source", GUILayout.Width(Width), GUILayout.Height(Height)))
        {
            Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/");
        }
    }

    public static void wikiButton(int Width, int Height)
    {
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Show Wiki", GUILayout.Width(Width), GUILayout.Height(Height)))
        {
            Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/wiki");
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    public static void ShurikenHeader(string title)
    {
        DrawShuriken(title, new Vector2(6f, -2f), 22);
    }

    public static void ShurikenHeaderCentered(string title)
    {
        DrawShurikenCenteredTitle(title, new Vector2(0f, -2f), 22);
    }

    public static void DrawShurikenPartingLineText(string title)
    {
        DrawShurikenPartingLineText(title, new Vector2(6f, -2f), 22);
    }

    public static void DrawButtons()
    {
        ACLStyles.PartingLine();
        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        ACLStyles.gitVersionCheckButton(100,30);
        ACLStyles.gitSourcebutton(100, 30);
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
        ACLStyles.wikiButton(100,30);
    }
}